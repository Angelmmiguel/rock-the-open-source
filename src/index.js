import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import registerServiceWorker from './registerServiceWorker';

// Firebase
import * as firebase from 'firebase';

// Styles
import './index.css';

// Config
var config = {
  apiKey: process.env.REACT_APP_FIREBASE_APIKEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTHDOMAIN,
  databaseURL: process.env.REACT_APP_FIREBASE_DATABASEURL,
  projectId: process.env.REACT_APP_FIREBASE_PROJECTID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGEBUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGINGSENDERID
};

// Initialize firebase!
firebase.initializeApp(config);

// Render!
ReactDOM.render(
  <App firebase={ firebase } />,
  document.getElementById('root')
);

// Offline
registerServiceWorker();
