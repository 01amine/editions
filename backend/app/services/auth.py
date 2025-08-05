from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta
from app.models.user import User
from typing import Optional
from app.config import settings
from itsdangerous import URLSafeTimedSerializer 

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
SECRET_KEY = settings.JWT_SECRET
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1000


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)


async def authenticate_user(email: str, password: str) -> Optional[User]:
    user = await User.find_one(User.email == email)
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (
        expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_reset_token(email: str) -> str:
    s = URLSafeTimedSerializer(settings.SECRET_KEY)
    return s.dumps(email, salt="password-reset")

def verify_reset_token(token: str, expires_sec: int = settings.PASSWORD_RESET_TOKEN_EXPIRES) -> str:
    s = URLSafeTimedSerializer(settings.SECRET_KEY)
    try:
        email = s.loads(token, salt="password-reset", max_age=expires_sec)
    except Exception:
        return None
    return email
