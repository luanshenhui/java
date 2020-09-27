import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import axios from 'axios';

// Material-UIのCssBaselineによるCSS Reset
import CssBaseline from '@material-ui/core/CssBaseline';

import { MuiThemeProvider, createMuiTheme } from '@material-ui/core/styles';

import ItemAndGroupGuideContainer from './containers/common/ItemAndGroupGuideContainer';
import SentenceGuideContainer from './containers/common/SentenceGuideContainer';

// Store設定用関数のインポート
import store from './store';

import App from './components/App';

// IE11 axiosキャッシュ対策処理
axios.interceptors.request.use((orgConfig) => {
  const config = { ...orgConfig };
  if (typeof config.params === 'undefined') {
    config.params = {};
  }
  if (typeof config.params === 'object') {
    if (typeof URLSearchParams === 'function' && config.params instanceof URLSearchParams) {
      config.params.append('_', Date.now());
    } else {
      config.params._ = Date.now();
    }
  }
  return config;
});

const theme = createMuiTheme({
  palette: {
    background: {
      default: '#ffffff',
    },
  },
});

ReactDOM.render(
  <Provider store={store()}>
    <MuiThemeProvider theme={theme}>
      <CssBaseline />
      <App />
      <ItemAndGroupGuideContainer />
      <SentenceGuideContainer />
    </MuiThemeProvider>
  </Provider>,
  document.getElementById('root'),
);
