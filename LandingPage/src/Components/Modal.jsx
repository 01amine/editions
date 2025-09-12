import {React} from 'react';
import { useTranslation } from 'react-i18next'
import Data from '../assets/QrCode.svg'
const Modal = ({ open, onClose }) => {
  const { t , i18n } = useTranslation();
  if (!open) return null;
  return (
    <div onClick={onClose} className='overlay z-99'>
      <div
        onClick={(e) => {
          e.stopPropagation();
        }}
        className='modalContainer my-16'
      >
        <div className='modalRight'>
          <div className='content flex justify-center items-center'>
            <p className="py-2 font-sans text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl sm:leading-none">
                {t("modal.title")}
                <span className="relative text-green-accent-800"> {t("modal.titlegreen")}</span>
            </p>
            <p className="py-2 font-sans tracking-tight text-gray-900 sm:text-2xl sm:leading-none">{t("modal.subtitle")}</p>
            <p className="font-sans tracking-tight text-gray-900 sm:text-xl sm:leading-none">{t("modal.description")}</p>
            <img className='pt-4' src={Data} alt="" />
            <br />
          </div>
          <div className='btnContainer'>
            <button className='inline-flex items-center justify-center h-12 px-6 mr-6 font-medium tracking-wide text-white transition duration-200 rounded shadow-md bg-green-accent-800 hover:bg-green-accent-700 focus:shadow-outline focus:outline-none' onClick={onClose}>
              <span className='bold'>{t("modal.button")}</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Modal;