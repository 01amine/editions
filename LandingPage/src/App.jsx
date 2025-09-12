import react from 'react'
import Header from './Components/Header'
import Feature from  './Components/Feature'
import Contact from './Components/Contact'
import Footer from './Components/Footer'
import Steps from './Components/Steps'
import OurApps from './Components/OurApps'
import NavBar from './Components/NavBar'
import Service from './Components/Service'
import { useTranslation } from 'react-i18next'
function App() {
  const { t , i18n } = useTranslation();
  return (
    <div className={`${i18n.language === 'ar' ? 'font-arabic' :'font-sans' }`}>
      <NavBar/>
      <Header />
      <OurApps />
      <Feature />
      <Service />
      <Steps />
      <Contact />
      <Footer />
    </div>
  )
}

export default App
