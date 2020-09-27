import React from 'react';
import { Link } from 'react-router-dom';

import PageLayout from '../../layouts/PageLayout';

const Menu = () => (
  <PageLayout title="誘導">
    <ul>
      <li><Link to="/contents/yudo/shinsatsureflesh">診察状態</Link></li>
    </ul>
  </PageLayout>
);

export default Menu;
