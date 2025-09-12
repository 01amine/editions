import React from 'react'
import Online from "../assets/boy online doctor.svg";
import Onsite from "../assets/female doctor at desk.svg";
import Athome from "../assets/Doctor with grandfather.svg";
import { useTranslation } from 'react-i18next'

const Service = () => {
  const { t , i18n } = useTranslation();  const imageStyle = "object-contain h-full w-full max-w-xs mx-auto border shadow-2xl rounded-2xl"; // Added max-w-xs to control size
  const containerStyle = "flex h-full flex-col justify-center border border-green-accent-800 bg-gray-50 rounded-3xl p-8";
  const imageContainerStyle = "relative overflow-hidden border border-green-accent-800 rounded-3xl max-h-[300px] lg:max-h-[500px] max-w-[100%] lg:max-w-[685px] mx-auto";
    return (
        <section className="mx-auto py-5 sm:max-w-xl md:max-w-full lg:max-w-screen-xl lg:px-12  dark:bg-gray-white">
            <div>
                <h1 className="sm:text-3xl text-4xl font-semibold px-10 tracking-tighter text-gray-900 lg:text-6xl text-balance">
                    {t("service.title")}{" "}
                    <br className="hidden md:block" />
                    <span className="text-green-accent-800 mt-4 leading-10"> {t("service.titlegreen")}</span>
                </h1>
                <p className="mt-4 text-base font-semibold px-10 mb-6 text-gray-700 text-balance">
                    {t("service.description")}
                </p>
            </div>
            <div className="container rounded-sm mx-auto space-y-12">
                <div className="flex flex-col overflow-hidden rounded-tr-3xl  shadow-sm lg:flex-row">
                    <img src={Onsite} alt="On-site Sessions" className="lg:w-1/2 lg:max-w-lg h-80 object-contain dark:bg-gray-200" />
                    <div className="flex flex-col justify-center flex-1 p-6 bg-gray-50">
                        <h3 className="text-3xl font-bold">{t("service.services.service1.title")}</h3>
                        <p className="my-6 dark:text-gray-600">{t("service.services.service1.description")}</p>
                    </div>
                </div>
                <div className="flex flex-col overflow-hidden rounded-tl-3xl shadow-sm lg:flex-row-reverse">
                    <img src={Athome} alt="Home visits" className="lg:w-1/2 lg:max-w-lg h-80 object-contain dark:bg-gray-200 aspect-video" />
                    <div className="flex flex-col justify-center flex-1 p-6 bg-gray-50">
                        <h3 className="text-3xl font-bold">{t("service.services.service2.title")}</h3>
                        <p className="my-6 dark:text-gray-600">{t("service.services.service2.description")}</p>
                    </div>
                </div>
                <div className="flex flex-col overflow-hidden rounded-tr-3xl shadow-sm lg:flex-row">
                    <img src={Online} alt="Virtual Meetings" className="lg:w-1/2 lg:max-w-lg h-80 object-contain dark:bg-gray-200 aspect-video" />
                    <div className="flex flex-col justify-center flex-1 p-6 bg-gray-50">
                        <h3 className="text-3xl font-bold"> {t("service.services.service3.title")}</h3>
                        <p className="my-6 dark:text-gray-600">{t("service.services.service3.description")}</p>
                    </div>
                </div>
            </div>
        </section>
      )
}

export default Service