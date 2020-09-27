import React from 'react';

import PageLayout from '../layouts/PageLayout';
import SectionBar from '../components/SectionBar';

const ChipExample = () => (
  <div>
    <PageLayout title="ページタイトル">
      <p>コンテンツ</p>
      <SectionBar title="セクション名" />
      <p>サブコンテンツ</p>
    </PageLayout>
  </div>
);

export default ChipExample;
