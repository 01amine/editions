import {React,useState} from 'react'
import { useTranslation } from 'react-i18next'
import Modal from './Modal'
const OurApps = () => {
  const { t , i18n } = useTranslation();
  const [openModal, setOpenModal] = useState(false);
  return (
<section id='ourapp' className="lg:mx-auto py-5 px-10  mx-auto sm:max-w-xl md:max-w-full lg:max-w-screen-xl md:px-24 lg:px-12 lg:py-20 ">
  <div className="max-w-xl md:max-w-2xl sm:text-center sm:mx-auto">
    <h2 className="mb-6 font-sans text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl sm:leading-none">
      <span className="relative inline-block">
        {t("ourapps.title")}
      </span>
      <span className="relative text-green-accent-800"> {t("ourapps.titlegreen")} </span>
    </h2>
    <div className="flex items-center mb-3 sm:justify-center">
      <a className="mr-3 transition duration-300 hover:shadow-lg cursor-pointer">
        <img
          src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Download_on_the_App_Store_Badge.svg/1000px-Download_on_the_App_Store_Badge.svg.png"
          className="object-cover object-top w-32 mx-auto md:w-48"
          alt=""
          onClick={() => setOpenModal(true)}
        />
      </a>
      <a className="transition duration-300 hover:shadow-lg cursor-pointer">
        <img
          src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Google_Play_Store_badge_EN.svg/1000px-Google_Play_Store_badge_EN.svg.png"
          className="object-cover object-top w-32 mx-auto md:w-48"
          alt=""
          onClick={() => setOpenModal(true)}
        />
      </a>
    </div>
    <p className="max-w-md text-xs text-gray-600 sm:text-sm md:text-base md:max-w-lg sm:mx-auto">
      {t("ourapps.description")}
    </p>
  </div>
  <Modal open={openModal} onClose={() => setOpenModal(false)} />
</section>
  )
}

export default OurApps
