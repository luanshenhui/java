import React from 'react';
import { Link } from 'react-router-dom';

import PageLayout from '../../layouts/PageLayout';

const Menu = () => (
  <PageLayout title="Test">
    <ul>
      <li><Link to="/contents/judgement/interview/top/420126/totaljudview/0/0">面接支援</Link></li>
    </ul>
  </PageLayout>
);

export default Menu;
