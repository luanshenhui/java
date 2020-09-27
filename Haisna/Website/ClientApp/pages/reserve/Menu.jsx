import React from 'react';
import { Link } from 'react-router-dom';
import MenuItem from '../../components/MenuItem';

import PageLayout from '../../layouts/PageLayout';

const Menu = () => (
  <PageLayout title="予約">
    <ul>
      <li><Link to="/contents/reserve/main">新規予約</Link></li>
      <li><Link to="/contents/reserve/perpaymentlist/671151">個人受診金額情報</Link></li>
    </ul>
    <MenuItem
      title="更新履歴"
      link="/contents/reserve/rsvLog"
      description="受診情報の変更履歴を表示します。"
      image=""
    />
    <MenuItem
      title="FailSafe"
      link="/contents/reserve/failsafe"
      description="契約情報との整合性チェックを行います。"
      image=""
    />
  </PageLayout>
);

export default Menu;
