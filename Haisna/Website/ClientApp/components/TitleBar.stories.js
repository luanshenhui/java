// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import { storiesOf } from '@storybook/react';
import { withInfo } from '@storybook/addon-info';

// コンポーネントのインポート
import TitleBar from './TitleBar';

// storyの追加
storiesOf('Molecules/TitleBar', module)
  .addDecorator((story) => (
    <div>
      <CssBaseline />
      {story()}
    </div>
  ))
  .add('report', withInfo({ inline: true })(() => <TitleBar type="report">印刷</TitleBar>))
  .add('maintenance', withInfo({ inline: true })(() => <TitleBar type="maintenance">メンテナンス</TitleBar>));
