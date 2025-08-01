from fastapi import APIRouter
from fastapi import APIRouter, HTTPException, status, Depends
# from app.schema.user import UserLogin, Token, UserCreate
from app.models.user import UserCreate
from app.services.auth import authenticate_user, create_access_token, hash_password
from app.models.user import User
from app.deps.auth import get_current_user
from fastapi.responses import JSONResponse
from app.config import settings

router = APIRouter()


@router.get("/")
async def get_user():
    return {"msg": "User route working"}


@router.post("/register")
async def register_user(data: UserCreate):
    if await User.find_one({"email": data.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    user = User(
        email=data.email,
        hashed_password=hash_password(data.password),
        full_name=data.full_name,
        organization_id=data.organization_id,
    )
    await user.insert()
    access_token = create_access_token(data={"sub": str(user.id)})
    if not access_token:
        raise HTTPException(status_code=500, detail="Could not create access token")
    response = JSONResponse(content={"access_token": access_token})
    response.set_cookie(
        key="access_token",
        value=access_token,
        httponly=True,
        secure=settings.ENV == "production",
        samesite="lax",
        max_age=24 * 60 * 60,  # 1day
    )
    return response


@router.post("/login")
async def login_user(credentials: UserCreate):
    user = await authenticate_user(credentials.email, credentials.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    access_token = create_access_token(data={"sub": str(user.id)})
    if not access_token:
        raise HTTPException(status_code=500, detail="Could not create access token")
    response = JSONResponse(content={"access_token": access_token})
    response.set_cookie(
        key="access_token",
        value=access_token,
        httponly=True,
        secure=settings.ENV == "production",
        samesite="lax",
        max_age=24 * 60 * 60,
    )
    return response


@router.get("/me", response_model=User)
async def read_me(current_user: User = Depends(get_current_user)):
    return current_user


@router.post("/logout")
async def logout_user():
    response = JSONResponse(content={"message": "Successfully logged out"})
    response.delete_cookie(
        key="access_token",
        httponly=True,
        secure=settings.ENV == "production",
        samesite="lax",
    )
    return response
