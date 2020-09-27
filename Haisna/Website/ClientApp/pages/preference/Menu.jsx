import React from 'react';
import PageLayout from '../../layouts/PageLayout';
import MenuItem from '../../components/MenuItem';

const Menu = () => (
  <PageLayout title="メンテナンスメニュー">
    <MenuItem
      title="個人情報"
      link="/contents/preference/person"
      description="個人情報として設定している内容確認。及びその内容の変更はこちらから。"
      image=""
    />
    <MenuItem
      title="団体情報"
      link="/contents/preference/organization"
      description="団体情報として設定している内容確認。及びその内容の変更はこちらから。"
      image=""
    />
    <MenuItem
      title="契約情報の参照、登録"
      link="/contents/preference/contract"
      description="団体毎に指定されたそれぞれの契約内容確認、及び新規契約情報の登録はこちらから。"
      image=""
    />
    <MenuItem
      title="予約枠登録、確認"
      link="/contents/preference/schedule/rsvfra"
      description="各コース、設備毎の予約可能人数の設定を行います。"
      image=""
    />
    <MenuItem
      title="休診日設定"
      link="/contents/preference/schedule/mntcapacity"
      description="祝日、休診日の設定を行います。"
      image=""
    />
    <MenuItem
      title="予約枠のコピー"
      link="/contents/preference/schedule/rsvfracopy1"
      description="すでに登録されている予約枠情報をコピーし、新しい予約枠を作成します。"
      image=""
    />
    <MenuItem
      title="成績書発送確認"
      link="/contents/preference/dispatch/sendCheck"
      description="成績書の発送確認を行います。"
      image=""
    />
    <MenuItem
      title="成績書発送進捗確認"
      link="/contents/preference/dispatch/inqReportsInfo"
      description="成績書作成の進捗確認を行います。"
      image=""
    />
    <MenuItem
      title="ログ参照"
      link="/contents/preference/hainslog"
      description="一括予約、請求締め処理などの実行ログを参照します。"
      image=""
    />
    <MenuItem
      title="ダウンロード"
      link="/contents/preference/hainslog/hainslog"
      description="webHainsシステム管理アプリケーション等のダウンロード。"
      image=""
    />
    <MenuItem
      title="端末管理"
      link="/contents/preference/workstation"
      description="端末管理を行います。"
      image=""
    />
  </PageLayout>
);

export default Menu;
