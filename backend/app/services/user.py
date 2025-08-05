from app.models.user import User
from bson import ObjectId


class UserService :
    @staticmethod 
    async def get_user_by_name(name:str)->User :
        return await User.find_one(User.full_name == name)
    @staticmethod
    async def get_user_by_id(id:str):
        return await User.find_one(User.id == ObjectId(id))
    
    