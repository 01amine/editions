from fastapi import FastAPI
from contextlib import asynccontextmanager
from app.api import conversation
from fastapi.staticfiles import StaticFiles
from app.config import settings
from app.models.coversation import Conversation
from pymongo import AsyncMongoClient
from beanie import init_beanie
from app.models.user import User
from app.api import payment, user



mongo_client = AsyncMongoClient(settings.MONGO_URI)
mongo_db = mongo_client[settings.MONGO_DB]

async def init_mongo():
    await init_beanie(database=mongo_db, document_models=[User])
@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_mongo()
    yield


app = FastAPI(lifespan=lifespan)

app.mount("/static", StaticFiles(directory="app/static"), name="static")
app.include_router(user.router, prefix="/users", tags=["Users"])
app.include_router(
    conversation.router, prefix="/conversations", tags=["Conversations"]
)
app.include_router(payment.router, prefix="/payments", tags=["Payments"])
