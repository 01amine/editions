import React, { useState, useEffect, useRef } from "react";
import { useTranslation } from 'react-i18next';

const LanguageSelector = () => {
  const { t, i18n } = useTranslation();
  const [selectedLanguage, setSelectedLanguage] = useState(localStorage.getItem('language') || i18n.language);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  useEffect(() => {
    if (selectedLanguage) {
      i18n.changeLanguage(selectedLanguage);
    }
  }, [selectedLanguage, i18n]);
  const options = [
    { value: 'ar', label: 'العربية', flag: 'fi fi-dz' },
    { value: 'en', label: 'English', flag: 'fi fi-gb' },
    { value: 'fr', label: 'French', flag: 'fi fi-fr' },

];
  const chooseLanguage = (language) => {
    i18n.changeLanguage(language);
    setSelectedLanguage(language);
    localStorage.setItem('language', language);
    setDropdownOpen(false);
  };

  const handleDropdownToggle = () => {
    setDropdownOpen(!dropdownOpen);
  };

  const handleClickOutside = (event) => {
    if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
      setDropdownOpen(false);
    }
  };

  useEffect(() => {
    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  const selectedOption = options.find(option => option.value === selectedLanguage);

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={handleDropdownToggle}
        className="flex items-center justify-center w-8 h-8 rounded-full bg-gray-200 dark:bg-gray-700"
      >
        <span className={`${selectedOption.flag} text-lg`} style={{ width: '1.5rem' }}></span>
      </button>
      {dropdownOpen && (
        <div className={`absolute ${selectedLanguage === 'ar' ? 'left-0' : 'right-0'} mt-2 w-36 rounded-md shadow-lg bg-white dark:bg-gray-800 z-10`}>
          <ul className="py-1">
            {options.map(option => (
              <li
                key={option.value}
                onClick={() => chooseLanguage(option.value)}
                className="flex items-center px-4 py-2 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700"
              >
                <span className={`${option.flag} text-lg `} style={{ width: '1.5rem' }}></span>
                <span className={`text-sm text-black dark:text-white ${selectedLanguage === 'ar' ? 'pr-2' : 'pl-2'}`}>{option.label}</span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default LanguageSelector;