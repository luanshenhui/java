/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { withInfo } from '@storybook/addon-info';

import { storiesOf } from '@storybook/react';

import BulletedLabel from './BulletedLabel';

storiesOf('Controls', module)
  .add('BulletedLabel', withInfo({ inline: true })(() => <BulletedLabel>Hello World.</BulletedLabel>));
