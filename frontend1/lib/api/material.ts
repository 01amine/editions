import { API_ENDPOINTS } from "../const/endpoint";
import { MaterialsAdmin } from "../types/material";
import client from "./clients";

export async function getMaterials(limit : number = 10, skip : number = 0): Promise<MaterialsAdmin[]> {
    const { data } = await client.get<MaterialsAdmin[]>(API_ENDPOINTS.MATERIALS.ROOT, {
        params: { limit, skip },
    });
    if (!data) {
        throw new Error("No materials found");
    }
    return data;
   
}

export async function getMaterialById(id : string): Promise<MaterialsAdmin> {
    const { data } = await client.get<MaterialsAdmin>(API_ENDPOINTS.MATERIALS.BY_ID_ADMIN(id));
    if (!data) {
        throw new Error("No material found");
    }
    return data;
}

export async function deleteMaterialById(id : string): Promise<void> {
    await client.delete(API_ENDPOINTS.MATERIALS.BY_ID_ADMIN(id));
}

export async function editMaterialById(id : string, data : MaterialsAdmin): Promise<void> {
    await client.patch(API_ENDPOINTS.MATERIALS.BY_ID(id), data);
}
