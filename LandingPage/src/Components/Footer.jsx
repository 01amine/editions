import React , {useState} from "react";
import Vector from '../assets/logo.png'
import { footerLinks } from "./Constants";
import { useTranslation } from 'react-i18next'
import emailjs from '@emailjs/browser'
import { Button, message } from 'antd';

const Footer = () => {
  const [email,setEmail] = useState('');
  const [messageApi, contextHolder] = message.useMessage();
  const handlesubscribor = (e) => {
    e.preventDefault();
    const serviceId = 'service_4dg1efm';
    const templateIt = 'template_g6hfsn7';
    const publicKey = 'fbXMMNFn6YSwq3cA1';
    const templateParams = {
        email : email ,
        to_name : "Lectio Assistants" ,
    }
    const success = () => {
      messageApi.success(t('footer.successmessage'), 2.5);
    };
    const faild = () => {
      messageApi.error(t('footer.errormessage'), 2.5);
    };
    emailjs.send(serviceId,templateIt,templateParams,publicKey)
    .then ((response)=>{
        setEmail('');
        success();
      })
      .catch((error)=>{
        console.error('Error Sending email :',error);
        faild();
      })
    }
    const { t, i18n } = useTranslation();
    const isArabic = i18n.language === 'ar';
    return (
      <div className="relative mt-16 bg-green-accent-800 ">
      {contextHolder}
      <svg
        className="absolute top-0 w-full h-6 -mt-5 sm:-mt-10 sm:h-16 text-green-accent-800"
        preserveAspectRatio="none"
        viewBox="0 0 1440 54"
      >
        <path
          fill="currentColor"
          d="M0 22L120 16.7C240 11 480 1.00001 720 0.700012C960 1.00001 1200 11 1320 16.7L1440 22V54H1320C1200 54 960 54 720 54C480 54 240 54 120 54H0V22Z"
        />
      </svg>
      <div className="px-4  pt-12 mx-auto sm:max-w-xl md:max-w-full lg:max-w-screen-xl md:px-24 lg:px-12">
        <div className="grid gap-16 row-gap-10 mb-8 lg:grid-cols-6">
          <div className="md:max-w-md lg:col-span-2">
            <a
              href="/"
              aria-label="Go home"
              title="Company"
              className="inline-flex items-center"
            >
              <img src={Vector} alt="logo" className=' object-contain'/>
            </a>
            <div className="mt-4 lg:max-w-sm">
              <p className="text-sm text">
                {t("footer.description")}
              </p>
              <p className="mt-4 text-sm text">
                {t("footer.description2")}
              </p>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-5 row-gap-8 lg:col-span-4 md:grid-cols-4">
          {footerLinks.map((footerlink) => (
            <div key={footerlink.title}>
              <p className="font-semibold tracking-wide text-white">
                {t(`footer.links.${footerlink.title}.title`)}
              </p>
              <ul className="mt-2 space-y-2">
                {footerlink.links.map((link, index) => (
                  <li key={link.name}>
                    <a href="/" className=" text hover:text-white">{t(`footer.links.${footerlink.title}.${link.name}`)}</a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
            <div className="md:max-w-md lg:col-span-2">
            <span className="text-base font-medium tracking-wide text-white">
              {t("footer.subscribtion.title")}
            </span>
            <form 
              className="flex flex-col mt-4 md:flex-row "
              onSubmit={handlesubscribor}
              >
              <input
                placeholder="Email"
                required
                type="text"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="flex-grow md:w-40 w-full h-12 px-4 mx-2 mb-3  transition duration-200 bg-white border border-gray-300 rounded shadow-sm appearance-none md:mr-2 md:mb-0 focus:border-green-accent-800 focus:outline-none focus:shadow-outline"
              />
              <Button
                type="submit"
                className="inline-flex items-center justify-center h-12 px-6  font-medium tracking-wide text-white transition duration-200 rounded shadow-md drop-shadow-md bg-gradient-to-r from-start to-end  hover:from-hover_colors-hover-start hover:to-hover_colors-hover-end focus:shadow-outline focus:outline-none "
                onClick={handlesubscribor}
              >
                {t("footer.subscribtion.button")}
              </Button>
            </form>
            <p className="mt-4 text-sm text">
              {t("footer.subscribtion.description")}
            </p>
          </div>
          </div>
        </div>
        <div className="flex flex-col justify-center pt-5 pb-10 border-t border-green-accent-400 sm:flex-row">
          <p className="text-sm text px-2">
            {t("footer.copyrights")}
          </p>
          <div className={`flex items-center justify-between mt-4 space-x-4 sm:mt-0 ${isArabic ? 'space-x-reverse' : ''}`}>
            <a
              href="/https://twitter.com/CareWellSaaS"
              className=" text-white hover:text-deep-purple-100"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" className="h-5">
                <path d="M24,4.6c-0.9,0.4-1.8,0.7-2.8,0.8c1-0.6,1.8-1.6,2.2-2.7c-1,0.6-2,1-3.1,1.2c-0.9-1-2.2-1.6-3.6-1.6 c-2.7,0-4.9,2.2-4.9,4.9c0,0.4,0,0.8,0.1,1.1C7.7,8.1,4.1,6.1,1.7,3.1C1.2,3.9,1,4.7,1,5.6c0,1.7,0.9,3.2,2.2,4.1 C2.4,9.7,1.6,9.5,1,9.1c0,0,0,0,0,0.1c0,2.4,1.7,4.4,3.9,4.8c-0.4,0.1-0.8,0.2-1.3,0.2c-0.3,0-0.6,0-0.9-0.1c0.6,2,2.4,3.4,4.6,3.4 c-1.7,1.3-3.8,2.1-6.1,2.1c-0.4,0-0.8,0-1.2-0.1c2.2,1.4,4.8,2.2,7.5,2.2c9.1,0,14-7.5,14-14c0-0.2,0-0.4,0-0.6 C22.5,6.4,23.3,5.5,24,4.6z" />
              </svg>
            </a>
            <a
              href="https://www.instagram.com/care.well.dz"
              className=" text-white hover:text-deep-purple-100"
            >
              <svg viewBox="0 0 30 30" fill="currentColor" className="h-6">
                <circle cx="15" cy="15" r="4" />
                <path d="M19.999,3h-10C6.14,3,3,6.141,3,10.001v10C3,23.86,6.141,27,10.001,27h10C23.86,27,27,23.859,27,19.999v-10   C27,6.14,23.859,3,19.999,3z M15,21c-3.309,0-6-2.691-6-6s2.691-6,6-6s6,2.691,6,6S18.309,21,15,21z M22,9c-0.552,0-1-0.448-1-1   c0-0.552,0.448-1,1-1s1,0.448,1,1C23,8.552,22.552,9,22,9z" />
              </svg>
            </a>
            <a
              href="https://www.linkedin.com/company/care-well-saas/about/"
              className=" text-white hover:text-deep-purple-100"
            >
            <svg viewBox="0 0 24 24" fill="currentColor" className="h-6">
              <path d="M15.2 8.80005C16.4731 8.80005 17.694 9.30576 18.5941 10.2059C19.4943 11.1061 20 12.327 20 13.6V19.2H16.8V13.6C16.8 13.1757 16.6315 12.7687 16.3314 12.4687C16.0313 12.1686 15.6244 12 15.2 12C14.7757 12 14.3687 12.1686 14.0687 12.4687C13.7686 12.7687 13.6 13.1757 13.6 13.6V19.2H10.4V13.6C10.4 12.327 10.9057 11.1061 11.8059 10.2059C12.7061 9.30576 13.927 8.80005 15.2 8.80005Z" fill="currentColor" />
              <path d="M7.2 9.6001H4V19.2001H7.2V9.6001Z" fill="currentColor" />
              <path d="M5.6 7.2C6.48366 7.2 7.2 6.48366 7.2 5.6C7.2 4.71634 6.48366 4 5.6 4C4.71634 4 4 4.71634 4 5.6C4 6.48366 4.71634 7.2 5.6 7.2Z" fill="currentColor" />
            </svg>
            </a>
          </div>
        </div>
      </div>
    </div> 
    );
  }

export default Footer;