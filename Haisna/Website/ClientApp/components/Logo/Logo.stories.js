// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import { storiesOf } from '@storybook/react';
import { withInfo } from '@storybook/addon-info';

// コンポーネントのインポート
import Logo from './Logo';

// storyの追加
storiesOf('Atoms/Logo', module)
  .addDecorator((story) => (
    <div>
      <CssBaseline />
      <div style={{ backgroundColor: '#666666' }}>
        {story()}
      </div>
    </div>
  ))
  .add('default', withInfo({ inline: true })(() => <Logo />));
