import React, { useState } from 'react';
import { navLinks } from './Constants';
import Vector from '../assets/logo.png';
import LanguageSelector from './LanguageSelector';
import { useTranslation } from 'react-i18next'
const NavBar = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const { t , i18n } = useTranslation();
  const isArabic = i18n.language === 'ar';
    return (
      <div className={`px-4 mx-auto  py-2 sm:max-w-xl md:max-w-full  lg:max-w-screen-xl md:px-24 lg:px-24 `} >
        <div className={`relative flex items-center justify-between ${isArabic ? "rtl" : "ltr"}`}>
          <a
            href="/"
            aria-label="lectio"
            title="lectio"
            className="inline-flex items-center "
          >
            <img src={Vector} alt="logo" className="w-[140px] h-[120px] object-contain " />
          </a>
          <ul className={`flex items-center hidden space-x-8 lg:flex ${isArabic ? 'space-x-reverse' : ''}`}>
            {navLinks.map((nav, index) => (
              <li key={index}>
                <a href={`#${nav.id}`} aria-label={`${nav.aria_label}`} title={`${nav.title}`} className="font-medium tracking-wide text-gray-700 transition-colors duration-200 hover:text-green-accent-400">
                  {t(`navbar.${nav.title}`)}
                </a>
              </li>
            ))}
            <li><LanguageSelector /></li>
          </ul>
          <div className="lg:hidden">
            <button
              aria-label="Open Menu"
              title="Open Menu"
              className="p-2 -ml-1 transition duration-200 rounded focus:outline-none focus:shadow-outline hover:bg-deep-purple-50 focus:bg-deep-purple-50"
              onClick={() => setIsMenuOpen(true)}
            >
              <svg className="w-5 text-gray-600" viewBox="0 0 24 24">
                <path
                  fill="currentColor"
                  d="M1,13h22c0.6,0,1-0.4,1-1s-0.4-1-1-1H1c-0.6,0-1,0.4-1,1S0.4,13,1,13z"
                />
                <path
                  fill="currentColor"
                  d="M1,6h22c0.6,0,1-0.4,1-1s-0.4-1-1-1H1C0.4,4,0,4.4,0,5S0.4,6,1,6z"
                />
                <path
                  fill="currentColor"
                  d="M1,20h22c0.6,0,1-0.4,1-1s-0.4-1-1-1H1c-0.6,0-1,0.4-1,1S0.4,20,1,20z"
                />
              </svg>
            </button>
            {isMenuOpen && (
              <div className="absolute top-0 right-0 w-full">
                <div className="p-5 bg-white border rounded shadow-sm">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <a href="/" aria-label="lectio" title="lectio">
                        <img src={Vector} alt="logo" className="w-[140px] h-[120px] object-contain"/>
                      </a>
                    </div>
                    <div>
                      <button
                        aria-label="Close Menu"
                        title="Close Menu"
                        className="p-2 -mt-2 -ml-2 transition duration-200 rounded hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
                        onClick={() => setIsMenuOpen(false)}
                      >
                        <svg className="w-5 text-gray-600" viewBox="0 0 24 24">
                          <path
                            fill="currentColor"
                            d="M19.7,4.3c-0.4-0.4-1-0.4-1.4,0L12,10.6L5.7,4.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l6.3,6.3l-6.3,6.3 c-0.4,0.4-0.4,1,0,1.4C4.5,19.9,4.7,20,5,20s0.5-0.1,0.7-0.3l6.3-6.3l6.3,6.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3 c0.4-0.4,0.4-1,0-1.4L13.4,12l6.3-6.3C20.1,5.3,20.1,4.7,19.7,4.3z"
                          />
                        </svg>
                      </button>
                    </div>
                  </div>
                  <nav>
                    <ul className="space-y-4">
                      {navLinks.map((nav, index) => (
                        <li key={index}>
                          <a href={`#${nav.id}`} aria-label={`${nav.aria_label}`} title={`${nav.title}`} className="font-medium tracking-wide text-gray-700 transition-colors duration-200 hover:text-green-accent-400 ml-[32px]">
                          {t(`navbar.${nav.title}`)}
                          </a>
                        </li>
                      ))}
                      <li><LanguageSelector /></li>
                    </ul>
                  </nav>
                </div>
              </div>
            )}
          </div>
        </div>
    </div>
    );
//   }else if(i18n.language === 'ar'){
//     return (
//     <div className="px-4 py-2 mx-auto sm:max-w-xl md:max-w-full lg:max-w-screen-xl md:px-24 lg:px-8" style={{ direction: 'rtl' }}>
//       <div className="relative flex items-center justify-between">
//       <a
//         href="/"
//         aria-label="medibook"
//         title="medibook"
//         className="inline-flex items-center"
//       >
//         <img src={Vector} alt="logo" className="w-[140px] h-[120px] object-contain" />
//       </a>
//       <ul className="flex items-center hidden  lg:flex">
//         {navLinks.map((nav, index) => (
//           <li key={index}>
//             <a href={`#${nav.id}`} aria-label={`${nav.aria_label}`} title={`${nav.title}`} className="font-medium tracking-wide text-gray-700 transition-colors duration-200 hover:text-green-accent-400 ml-[32px]">
//               {t(nav.title)}
//             </a>
//           </li>
//         ))}
//         <li><LanguageSelector /></li>
//       </ul>
//       <div className="lg:hidden">
//         <button
//           aria-label="Open Menu"
//           title="Open Menu"
//           className="p-2 -ml-1 transition duration-200 rounded focus:outline-none focus:shadow-outline hover:bg-deep-purple-50 focus:bg-deep-purple-50"
//           onClick={() => setIsMenuOpen(true)}
//         >
//           <svg className="w-5 text-gray-600" viewBox="0 0 24 24">
//             <path
//               fill="currentColor"
//               d="M1,13h22c0.6,0,1-0.4,1-1s-0.4-1-1-1H1c-0.6,0-1,0.4-1,1S0.4,13,1,13z"
//             />
//             <path
//               fill="currentColor"
//               d="M1,6h22c0.6,0,1-0.4,1-1s-0.4-1-1-1H1C0.4,4,0,4.4,0,5S0.4,6,1,6z"
//             />
//             <path
//               fill="currentColor"
//               d="M1,20h22c0.6,0,1-0.4,1-1s-0.4-1-1-1H1c-0.6,0-1,0.4-1,1S0.4,20,1,20z"
//             />
//           </svg>
//         </button>
//         {isMenuOpen && (
//           <div className="absolute top-0 right-0 w-full">
//             <div className="p-5 bg-white border rounded shadow-sm">
//               <div className="flex items-center justify-between mb-4">
//                 <div>
//                   <a
//                     href="/"
//                     aria-label="medibook"
//                     title="medibook"
//                     className="inline-flex items-center"
//                   >
//                     <img src={Vector} alt="logo" className="w-[140px] h-[120px] object-contain" />
//                   </a>
//                 </div>
//                 <div>
//                   <button
//                     aria-label="Close Menu"
//                     title="Close Menu"
//                     className="p-2 -mt-2 -ml-2 transition duration-200 rounded hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
//                     onClick={() => setIsMenuOpen(false)}
//                   >
//                     <svg className="w-5 text-gray-600" viewBox="0 0 24 24">
//                       <path
//                         fill="currentColor"
//                         d="M19.7,4.3c-0.4-0.4-1-0.4-1.4,0L12,10.6L5.7,4.3c-0.4-0.4-1-0.4-1.4,0s-0.4,1,0,1.4l6.3,6.3l-6.3,6.3 c-0.4,0.4-0.4,1,0,1.4C4.5,19.9,4.7,20,5,20s0.5-0.1,0.7-0.3l6.3-6.3l6.3,6.3c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3 c0.4-0.4,0.4-1,0-1.4L13.4,12l6.3-6.3C20.1,5.3,20.1,4.7,19.7,4.3z"
//                       />
//                     </svg>
//                   </button>
//                 </div>
//               </div>
//               <nav>
//                 <ul className="space-y-4">
//                 {navLinks.map((nav, index) => (
//                   <li key={index}>
//                     <a href={`#${nav.id}`} aria-label={`${nav.aria_label}`} title={`${nav.title}`} className="font-medium tracking-wide text-gray-700 transition-colors duration-200 hover:text-green-accent-400 ml-[32px]">
//                       {t(nav.title)}
//                     </a>
//                   </li>
//                 ))}
//                   <li><LanguageSelector /></li>
//                 </ul>
//               </nav>
//             </div>
//           </div>
//         )
//       }
//       </div>
//     </div>
// </div>
// )
//   }
}

export default NavBar;
