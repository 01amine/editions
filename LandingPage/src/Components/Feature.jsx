import React from 'react';
import { featureData } from './Constants/index';
import { useTranslation } from 'react-i18next';

const Feature = () => {
  const { t, i18n } = useTranslation();
    return (
      <section id='features' className="px-10 py-16 lg:mx-auto mx-auto sm:max-w-xl md:max-w-full lg:max-w-screen-xl md:px-24 lg:px-12 lg:py-20">
        <div className="max-w-lg mb-10 md:mx-auto sm:text-center lg:max-w-2xl md:mb-12">
          <div>
            <p className="inline-block px-3 py-px mb-4 text-xs font-semibold tracking-wider text-teal-900 uppercase z-999 rounded-full bg-teal-accent-400">
              {t("features.badge")}
            </p>
          </div>
          <h2 className="max-w-lg mb-6 font-sans text-3xl font-bold leading-none tracking-tight text-gray-900 sm:text-4xl md:mx-auto">
            <span className="relative inline-block">
              <span className="relative z-1">{t("features.title")}</span>
            </span> 
          </h2>
          <p className="text-base font-semibold text-gray-700 md:text-lg">
            {t("features.description")}
          </p>
        </div>
        <div className="grid gap-8 row-gap-5 mb-8 md:row-gap-8 lg:grid-cols-4 sm:grid-cols-2">
          {featureData.map((feature, index) => (
            <div key={feature.id} className="duration-300 transform bg-white border-l-4 border-green-accent-800 hover:-translate-y-2">
              <div className="h-full max-h-[510px] p-5 border border-l-0 rounded-r shadow-sm">
                <h6 className="mb-2 font-bold leading-5">{t(`features.cards.${feature.title}.title`)}</h6>
                <p className="text-sm font-semibold text-gray-700">{t(`features.cards.${feature.title}.description`)}</p>
              </div>
            </div>
          ))}
        </div>
      </section>
    );
};

export default Feature;
