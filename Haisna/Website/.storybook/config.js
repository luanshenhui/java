import { configure } from '@storybook/react';

const req = require.context('../ClientApp', true, /\.stories\.js$/);

const loadStories = () => req.keys().forEach((filename) => req(filename));

configure(loadStories, module);
