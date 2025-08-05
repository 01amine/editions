# from datetime import time
import time

from typing import Callable
from fastapi import Depends, HTTPException, Request
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from app.models.user import Role, User
from app.config import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login", auto_error=False)


async def get_current_user(request: Request, token: str = Depends(oauth2_scheme),) -> User:
    # First try to get token from cookie
    if not token:
        token = request.cookies.get("access_token")
        
    if not token:
        raise HTTPException(status_code=401, detail="No token provided")
    if request.method == "OPTIONS":
        return None

    
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=["HS256"])
        user_id: str = payload.get("sub") or ""
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid token payload")
        if payload.get("exp") < int(time.time()):
            raise HTTPException(status_code=498, detail="Token expired")
        user = await User.get(user_id)
        if user is None:
            raise HTTPException(status_code=401, detail="User not found")
        return user
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")


def role_required(*allowed_roles: Role) -> Callable:
    async def checker(user: User = Depends(get_current_user)):
        if user.isblocked:
            raise HTTPException(status_code=403, detail="User is blocked")
        if not any(role in user.roles for role in allowed_roles):
            raise HTTPException(status_code=403, detail="Insufficient permissions")
        return user
    return Depends(checker)
  

