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


export async function editMaterialById({
  id,
  data,
  newImages,
  existingImageUrls,
  newFile,
  removePdf
}: EditMaterialVars): Promise<void> {

  const formData = new FormData();

  if (data.title !== undefined) formData.append('title', data.title);
  if (data.description !== undefined) formData.append('description', data.description);
  if (data.material_type !== undefined) formData.append('material_type', data.material_type);
  if (data.price_dzd !== undefined) formData.append('price_dzd', String(data.price_dzd));
  if (data.study_year !== undefined) formData.append('year_study', data.study_year);
  if (data.specialite !== undefined) formData.append('specialite', data.specialite);
  if (data.module !== undefined) formData.append('module', data.module);

  existingImageUrls.forEach(url => {
    formData.append('existing_image_urls', url);
  });

  newImages.forEach(file => {
    formData.append('images', file);
  });

  if (newFile) {
    formData.append('file', newFile);
  }

  formData.append('remove_pdf', String(removePdf));

  await client.patch(API_ENDPOINTS.MATERIALS.BY_ID(id), formData);
}