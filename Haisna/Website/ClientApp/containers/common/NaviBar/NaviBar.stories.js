// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { Provider } from 'react-redux';
import BrowserRouter from 'react-router-dom/BrowserRouter';
import CssBaseline from '@material-ui/core/CssBaseline';
import { storiesOf } from '@storybook/react';

// Store設定用関数のインポート
import store from '../../../store';

// コンポーネントのインポート
import NaviBar from './NaviBar';

// storyの追加
storiesOf('Organisms/NaviBar', module)
  .addDecorator((story) => (
    <Provider store={store()}>
      <BrowserRouter>
        <div>
          <CssBaseline />
          {story()}
        </div>
      </BrowserRouter>
    </Provider>
  ))
  .add('default', () => <NaviBar onSubmit={(value) => console.log(value)} />);
