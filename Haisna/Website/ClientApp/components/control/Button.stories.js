/* eslint import/no-extraneous-dependencies: 0 */
import React from 'react';
import { withInfo } from '@storybook/addon-info';

import { storiesOf } from '@storybook/react';
import { action } from '@storybook/addon-actions';

import Button from './Button';

storiesOf('Controls', module)
  .add('Button', withInfo({ inline: true })(() => <Button onClick={action('clicked')} value="Hello Button" />));
