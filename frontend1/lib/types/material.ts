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