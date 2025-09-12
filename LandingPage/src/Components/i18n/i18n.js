import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import translationsInEng from "../locale/En-traslation.json"
import translationsInAra from "../locale/Ar-traslation.json"
import translationsInFr from "../locale/Fr-traslation.json"

// the translations
const resources = {
  en: {
    translation: translationsInEng
  },
  fr: {
    translation: translationsInFr
  },
  ar: {
    translation: translationsInAra
  },
};
const savedLanguage = localStorage.getItem('language') || 'ar';

i18n
  .use(initReactI18next) // passes i18n down to react-i18next
  .init({
    resources, // resources are important to load translations for the languages.
    lng: savedLanguage, // It acts as default language. When the site loads, content is shown in this language.  
    debug: true,
    supportedLngs: ['en', 'ar', 'fr'],
    fallbackLng: "en", // use de if selected language is not available
    interpolation: {
      escapeValue: false
    },
    react: {
      useSuspense: false
    },
    ns: "translation", // namespaces help to divide huge translations into multiple small files.
    defaultNS: "translation"
  });

export default i18n;