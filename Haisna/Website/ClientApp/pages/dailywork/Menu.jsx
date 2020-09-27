import React from 'react';
import MenuItem from '../../components/MenuItem';
import PageLayout from '../../layouts/PageLayout';

const Menu = () => (
  <PageLayout title="当日">
    <MenuItem
      title="来院処理"
      link="/contents/dailywork/ReceiptFrontDoor"
      description="受診者が来院されたときの処理を行います。"
      image=""
    />
    <MenuItem
      title="朝レポート"
      link="/contents/dailywork/MorningReportMain"
      description="朝レポートを表示します。"
      image=""
    />
    <MenuItem
      title="精度管理 "
      link="/contents/dailywork/MngaccuracyInfo"
      description="精度管理を表示します。"
      image=""
    />
  </PageLayout>
);

export default Menu;
