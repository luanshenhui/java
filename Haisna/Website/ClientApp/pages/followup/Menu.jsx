import React from 'react';
import PageLayout from '../../layouts/PageLayout';
import MenuItem from '../../components/MenuItem';

const Menu = () => (
  <PageLayout title="メンテナンスメニュー">
    <MenuItem
      title="フォローアップ検索"
      link="/contents/followup/FollowInfoList"
      description="フォローアップ対象者検索画面を表示します。"
      image=""
    />
    <MenuItem
      title="勧奨対象者検索"
      link="/contents/followup/"
      description="勧奨対象者検索画面を表示します。"
      image=""
    />
    <MenuItem
      title="依頼状発送確認"
      link="/contents/followup/"
      description="依頼状の発送確認を行います"
      image=""
    />
    <MenuItem
      title="依頼状発送進捗確認"
      link="/contents/followup/"
      description="依頼状発送の進捗確認を行います。"
      image=""
    />
  </PageLayout>
);

export default Menu;
