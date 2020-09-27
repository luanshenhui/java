/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { withInfo } from '@storybook/addon-info';

import { storiesOf } from '@storybook/react';

import Label from './Label';

storiesOf('Controls', module)
  .add('Label', withInfo({ inline: true })(() => <Label>Hello World.</Label>));
