from fastapi import FastAPI
from contextlib import asynccontextmanager
from fastapi.staticfiles import StaticFiles
from app.config import settings
from pymongo import AsyncMongoClient
from beanie import init_beanie
from app.models.user import User
from app.api.user import router as user_router
from app.api.appointement import router as appointement_router
from app.api.material import router as material_router
from app.api.order import router as order_router
from app.minio import init_minio_client
from app.models.appointemnt import Appointment
from app.models.material import Material
from app.models.order import Order



mongo_client = AsyncMongoClient(settings.MONGO_URI)
mongo_db = mongo_client[settings.MONGO_DB]

async def init_mongo():
    await init_beanie(database=mongo_db, document_models=[User,Material,Order,Appointment])
@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_mongo()
    await init_minio_client(
        minio_host=settings.MINIO_HOST,
        minio_port=settings.MINIO_PORT,
        minio_root_user=settings.MINIO_ROOT_USER,
        minio_root_password=settings.MINIO_ROOT_PASSWORD
        
  
    )
    yield


app = FastAPI(lifespan=lifespan)

app.mount("/static", StaticFiles(directory="app/static"), name="static")
app.include_router(user_router, prefix="/users", tags=["Users"])
app.include_router(appointement_router, prefix="/appointements", tags=["Appointements"])
app.include_router(material_router, prefix="/materials", tags=["Materials"])
app.include_router(order_router, prefix="/orders", tags=["Orders"])

