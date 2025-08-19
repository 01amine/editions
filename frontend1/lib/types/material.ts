export interface Material {
  id: string;
  title: string;
  description: string;
  image_urls: string[]; 
  material_type: string; 
  price_dzd: number;
}

export interface MaterialsAdmin extends Material {
  study_year: string;
  specialite: string;
  module: string;
  pdf_url: string;
  created_at: string;
}


export interface EditMaterialVars {
  id: string;
  data: MaterialsAdmin;
}
export type MaterialUpdateData = {
  title?: string;
  description?: string;
  material_type?: string;
  price_dzd?: number;
  study_year?: string;
  specialite?: string;
  module?: string;
  image_urls?: string[];
  pdf_url?: string;
};
export type EditMaterialVars = {
  id: string;
  data: MaterialUpdateData;
  newImages: File[];
  existingImageUrls: string[]; 
  newFile: File | null;
  removePdf: boolean; 
};