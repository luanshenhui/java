import React from 'react';
import ReactDOM from 'react-dom';

import Login from './components/Login';

const render = (Component) => {
  ReactDOM.render(
    <Component />,
    document.getElementById('root'),
  );
};

render(Login);

// Webpack Hot Module Replacement API
if (module.hot) {
  module.hot.accept('./components/Login', () => {
    render(Login);
  });
}
