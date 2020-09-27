// @flow

/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import { storiesOf } from '@storybook/react';
import { withInfo } from '@storybook/addon-info';

// コンポーネントのインポート
import BusinessIcon from './BusinessIcon';

// storyの追加
storiesOf('Atoms/BusinessIcon', module)
  .addDecorator((story) => (
    <div>
      <CssBaseline />
      {story()}
    </div>
  ))
  .add('report', withInfo({ inline: true })(() => <BusinessIcon type="report" />))
  .add('maintenance', withInfo({ inline: true })(() => <BusinessIcon type="maintenance" />));
