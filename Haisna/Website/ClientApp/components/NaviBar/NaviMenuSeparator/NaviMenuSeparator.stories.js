// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import { storiesOf } from '@storybook/react';
import { withInfo } from '@storybook/addon-info';

// コンポーネントのインポート
import NaviMenuSeparator from './NaviMenuSeparator';

// storyの追加
storiesOf('Atoms/NaviMenuSeparator', module)
  .addDecorator((story) => (
    <div>
      <CssBaseline />
      {story()}
    </div>
  ))
  .add('default', withInfo({ inline: true })(() => <NaviMenuSeparator />));
