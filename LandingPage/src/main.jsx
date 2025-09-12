import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'
import i18n from './Components/i18n/i18n.js'
import { I18nextProvider } from 'react-i18next';

// Function to update the direction based on the current language
const updateDirection = (language) => {
  const isRTL = ['ar'].includes(language); // Add other RTL languages if needed
  document.documentElement.dir = isRTL ? 'rtl' : 'ltr';
};

// Initial direction setting
updateDirection(i18n.language);

// Listen for language changes and update direction
i18n.on('languageChanged', (language) => {
  updateDirection(language);
});
ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <I18nextProvider i18n={i18n}>
      <App />
    </I18nextProvider>
  </React.StrictMode>
)
