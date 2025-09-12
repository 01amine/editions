import React from 'react';
import Image from '../assets/female doctor and male doctor standing together.png';
import {steps} from './Constants/index';
import { useTranslation } from 'react-i18next'

const Steps = () => {
  const { t } = useTranslation();
    return (
      <section id='HowItWorks' className="px-auto lg:px-12 py-16 mx-auto sm:max-w-xl md:max-w-full lg:max-w-screen-xl md:px-24  lg:py-20">
        <div className="grid  lg:grid-cols-2 lg:gap-64">
          <div className="lg:py-6">
            <h1 className='text-4xl font-semibold tracking-tighter text-gray-900 leading-10 lg:text-6xl text-balance '>{t("steps.title")}</h1>
            {steps.map((step, index) => (
              <div className="flex mt-4" key={index}>
                <div className="flex flex-col items-center mr-4">
                  <div>
                    <div className="flex items-center justify-center w-10 h-10 border rounded-full">
                      <svg
                        className="w-4 text-green-accent-800"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        viewBox="0 0 24 24"
                      >
                        <line
                          fill="none"
                          strokeMiterlimit="10"
                          x1="12"
                          y1="2"
                          x2="12"
                          y2="22"
                        />
                        <polyline
                          fill="none"
                          strokeMiterlimit="10"
                          points="19,15 12,22 5,15"
                        />
                      </svg>
                    </div>
                  </div>
                  <div className="w-px h-full bg-gray-300" />
                </div>
                <div className="pt-1 pb-8">
                  <p className="mb-2 text-lg font-bold">{t('steps.step')} {step.number}</p>
                  <p className="font-semibold text-gray-600">
                    {t(`steps.${step.title}`)}
                  </p>
                </div>
              </div>
            ))}
          </div>
          <div className="relative mt-40">
            <img
              className="inset-0 object-cover w-[315px] rounded shadow-base lg:block  lg:h-[550px] hidden  "
              src={Image}
              alt="doctor"
            />
          </div>
        </div>
      </section>
    );
};

export default Steps;


