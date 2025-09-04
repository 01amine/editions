import httpx
import json
from typing import Optional, Dict, Any
from fastapi import HTTPException
from app.models.order import Order
from app.models.user import User
import os
from datetime import datetime


class ZRExpressService:
    def __init__(self):
        self.base_url = "https://procolis.com/api_v1"
        self.token = os.getenv("ZR_EXPRESS_TOKEN")
        self.api_key = os.getenv("ZR_EXPRESS_KEY")
        
        self.headers = {
            "Content-Type": "application/json",
            "token": self.token,
            "key": self.api_key
        }

    async def create_delivery(self, order: Order, user: User) -> Optional[str]:
        """
        Creates a delivery request with ZR Express
        Returns tracking ID if successful, None otherwise
        """
        try:
            
            total_amount = sum(
                material.price_dzd * qty 
                for material, qty in order.item
            )
            
            
            delivery_data = {
                "Colis": [
                    {
                        "Tracking": f"ORDER_{order.id}_{datetime.now().strftime('%Y%m%d%H%M')}",
                        "TypeLivraison": "0", 
                        "TypeColis": "0", 
                        "Confirmee": "", 
                        "Client": user.full_name or "Client",
                        "MobileA": order.delivery_phone or user.phone or "0000000000",
                        "MobileB": "0000000000",
                        "Adresse": order.delivery_address or "Adresse non fournie",
                        "IDWilaya": "31",  
                        "Commune": user.era,  
                        "Total": str(int(total_amount)),
                        "Note": f"Commande Lectio #{order.id}",
                        "TProduit": "Matériel d'impression",
                        "id_Externe": str(order.id),
                        "Source": ""
                    }
                ]
            }

            async with httpx.AsyncClient() as client:
                response = await client.post(
                    f"{self.base_url}/add_colis",
                    headers=self.headers,
                    json=delivery_data,
                    timeout=30.0
                )
                
                if response.status_code == 200:
                    result = response.json()
                    # Extract tracking ID from response
                    tracking_id = delivery_data["Colis"][0]["Tracking"]
                    return tracking_id
                else:
                    print(f"ZR Express API Error: {response.status_code} - {response.text}")
                    return None
                    
        except Exception as e:
            print(f"Error creating delivery: {str(e)}")
            return None

    async def get_delivery_status(self, tracking_ids: list) -> Optional[Dict[str, Any]]:
        """
        Get delivery status for tracking IDs
        """
        try:
            status_data = {
                "Colis": [{"Tracking": tracking_id} for tracking_id in tracking_ids]
            }

            async with httpx.AsyncClient() as client:
                response = await client.post(
                    f"{self.base_url}/lire",
                    headers=self.headers,
                    json=status_data,
                    timeout=30.0
                )
                
                if response.status_code == 200:
                    return response.json()
                else:
                    print(f"ZR Express Status API Error: {response.status_code} - {response.text}")
                    return None
                    
        except Exception as e:
            print(f"Error getting delivery status: {str(e)}")
            return None

    async def update_delivery_status(self, tracking_ids: list, new_status: str) -> bool:
        """
        Update delivery status (change to ready for pickup, etc.)
        """
        try:
            update_data = {
                "Colis": [{"Tracking": tracking_id} for tracking_id in tracking_ids]
            }

            async with httpx.AsyncClient() as client:
                response = await client.post(
                    f"{self.base_url}/pret",
                    headers=self.headers,
                    json=update_data,
                    timeout=30.0
                )
                
                return response.status_code == 200
                    
        except Exception as e:
            print(f"Error updating delivery status: {str(e)}")
            return False


zr_express_service = ZRExpressService()