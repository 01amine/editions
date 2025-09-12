// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBXgftf0XVvc8VpFjoEg1PVYaXjgo5kV0o",
  authDomain: "med-saas.firebaseapp.com",
  projectId: "med-saas",
  storageBucket: "med-saas.appspot.com",
  messagingSenderId: "992488969616",
  appId: "1:992488969616:web:9af6b7ec59fa12ecebcf15",
  measurementId: "G-7FZGZGJ62F"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);