from typing import List
from fastapi import APIRouter
from fastapi import APIRouter, HTTPException, Depends
from app.models.user import ResetPasswordRequest, Role, UserCreate, UserLogin
from app.services.auth import authenticate_user, create_access_token, get_reset_token, hash_password, verify_reset_token
from app.models.user import User
from app.deps.auth import get_current_user
from fastapi.responses import JSONResponse
from app.config import settings
from app.deps.auth import role_required
from app.utils import send_email

router = APIRouter( prefix="/users", tags=["Users"])


@router.post("/")
async def add_user(user: UserCreate):
    userpay = User(
        email=user.email,
        hashed_password=hash_password(user.password),
        full_name=user.full_name,
        phone_number=user.phone_number,
    )
    await userpay.insert()
    return {"message": "User added successfully"}


@router.post("/register")
async def register_user(data: UserCreate):
    if await User.find_one({"email": data.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    user = User(
        email=data.email,
        hashed_password=hash_password(data.password),
        full_name=data.full_name,
        phone_number=data.phone_number,
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
async def login_user(credentials: UserLogin):
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


@router.post("/add-admin/{user_id}")
async def add_admin(user: User = role_required(Role.Super_Admin), user_id: str = None):
    user = await User.find_one({"_id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.role = Role.ADMIN
    await user.save()
    return user

@router.delete("/remove-admin/{user_id}")
async def remove_admin(user: User = role_required(Role.Super_Admin), user_id: str = None):
    user = await User.find_one({"_id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.role = Role.USER
    await user.save()
    return user

@router.post("/block/{user_id}")
async def block_user(user: User = role_required(Role.Super_Admin), user_id: str = None):
    user = await User.find_one({"_id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.isblocked = True
    await user.save()
    return user

@router.put("/unblock/{user_id}")
async def unblock_user(user: User = role_required(Role.Super_Admin), user_id: str = None):
    user = await User.find_one({"_id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.isblocked = False
    await user.save()
    return user

@router.get("/all-users", response_model=List[User])
async def get_all_users_paginated(user: User = role_required(Role.Super_Admin,Role.ADMIN),
                                  skip: int = 0, limit: int = 10):
    return await User.find().skip(skip).limit(limit).to_list()

@router.get("/all-admins", response_model=List[User])
async def get_all_admins(user: User = role_required(Role.Super_Admin)):
    return await User.find({"role": Role.ADMIN}).to_list()

@router.get("/all-students", response_model=List[User])
async def get_all_students_paginated(user: User = role_required(Role.Super_Admin, Role.ADMIN), skip: int = 0, limit: int = 10):
    return await User.find({"role": Role.USER}).skip(skip).limit(limit).to_list()

@router.post("/me-super-admin")
async def make_me_super_admin(user: User = Depends(get_current_user)):
 

    if Role.Super_Admin not in user.roles:
        user.roles.append(Role.Super_Admin) 
        await user.save()
        return {"message": "User successfully granted Super_Admin role.", "user_roles": user.roles}
    else:
        return {"message": "User already has Super_Admin role.", "user_roles": user.roles}

@router.post("/me-admin")
async def make_me_admin(user: User = Depends(get_current_user)):
    if Role.ADMIN in user.roles:
        return {"message": "User already has Admin role.", "user_roles": user.roles}
    
    user.roles.append(Role.ADMIN)
    await user.save()
    return user


@router.post("/forget-password")
async def forget_password(email:str):
    user = await User.find_one({"email": email})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    token = get_reset_token(user.email)
    await send_email(user.email, token)
    return {"message": "Password reset email sent"}


@router.post("/reset-password")
async def reset_password(data: ResetPasswordRequest):
    email = verify_reset_token(data.token)
    if not email:
        raise HTTPException(status_code=400, detail="Invalid or expired token")
    
    user = await User.find_one({"email": email})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.hashed_password = hash_password(data.new_password)
    await user.save()
    return {"message": "Password successfully reset"}