import React from 'react';
import { Link } from 'react-router-dom';

import PageLayout from '../../layouts/PageLayout';

const Menu = () => (
  <PageLayout title="データ抽出">
    <ul>
      <li><Link to="/contents/download/personcsv">個人情報</Link></li>
    </ul>
  </PageLayout>
);

export default Menu;
