import React from 'react';
import { useState } from 'react';
import  phone from "../assets/Phone.svg";
import  phoneleft from "../assets/phone left.svg";
import { useTranslation } from 'react-i18next'
import Modal from './Modal'

const Header = () => {
    const [isOpen, setIsOpen] = useState(false);
    const toggleMenu = () => {
        setIsOpen(!isOpen);
    }; 
    const [openModal, setOpenModal] = useState(false);
    const { t , i18n } = useTranslation();
    const isArabic = i18n.language ; 
        return (
          <section className='lg:px-12 '>
            <div className="flex flex-col justify-center gap-48 items-center w-full lg:pt-5 max-w-full lg:flex-row md:px-8 ">
                <div className="pt-16 mb-5 lg:mb-0 lg:pt-32 lg:max-w-lg lg:pr-5">
                    <div className="max-w-xl mb-2 px-10">
                        <div>
                            <p className="inline-block px-3 py-px mb-4 text-xs font-bold tracking-wider text-black uppercase rounded-full bg-yellow-700">
                                {t("Header.badge")}
                            </p>
                        </div>
                        <h2 className="max-w-lg mb-6 font-sans text-4xl font-bold tracking-tight text-gray-900 sm:text-4xl sm:leading-none">
                            {t("Header.title")}
                            <br className="hidden md:block" />
                             <span className="inline-block text-green-accent-800">
                                {t("Header.titlegreen")}                        
                            </span>
                        </h2>
                        <p className="text-base text-gray-700 md:text-lg">
                            {t("Header.description")}
                        </p>
                    </div>
                    <div className={`flex items-center space-x-7 px-10 ${isArabic === 'ar' ? 'space-x-reverse ' :''}`}>
                    <a 
                          className="inline-flex items-center justify-center h-12 px-6 font-medium z-0 tracking-wide text-white transition duration-200 rounded shadow-md bg-gradient-to-r from-start to-end  hover:from-hover_colors-hover-start hover:to-hover_colors-hover-end focus:shadow-outline focus:outline-none cursor-pointer animate-bounce"
                          onClick={() => setOpenModal(true)}                        
                      >
                          {t("Header.primarybutton")}
                    </a>
                    <a
                          href="#features"
                          aria-label=""
                          className="inline-flex items-center font-semibold transition-colors duration-200  text-green-accent-800 hover:text-green-accent-800"
                      >
                          {t("Header.secondarybutton")}
                      </a>
                    </div>
                </div>
                <div className="hidden sm:hidden md:hidden lg:block">
                    <img
                        src={`${isArabic === 'ar' ? phone : phoneleft}`}
                        className={`object-cover w-full ${isArabic === 'ar' ? "h-[600px]" : "lg:h-[500px] my-10"}  mx-auto md:max-w-sm rounded-3xl`}
                        alt=""
                    />
                </div>
                <Modal open={openModal}  onClose={() => setOpenModal(false)} />
            </div>
            </section>
        );   
};

export default Header;
