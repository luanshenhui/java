// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import { storiesOf } from '@storybook/react';
import { withInfo } from '@storybook/addon-info';

// コンポーネントのインポート
import NaviSearchButton from './NaviSearchButton';

// storyの追加
storiesOf('Molecules/NaviSearchButton', module)
  .addDecorator((story) => (
    <div>
      <CssBaseline />
      {story()}
    </div>
  ))
  .add('default', withInfo({ inline: true })(() => (
    <NaviSearchButton />
  )));
