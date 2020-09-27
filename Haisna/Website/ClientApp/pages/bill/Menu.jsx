import React from 'react';

import PageLayout from '../../layouts/PageLayout';
import MenuItem from '../../components/MenuItem';

const Menu = () => (
  <PageLayout title="請求処理">

    <MenuItem
      title="個人請求書の検索"
      link="/contents/demand/perbill/perBillSearch"
      description="個人請求書を検索します。"
      image=""
    />
    <MenuItem
      title="個人請求書新規作成処理"
      link="/contents/demand/perbill/createPerBill"
      description="個人請求情報を作成します。"
      image=""
    />
    <MenuItem
      title="個人受診金額再作成"
      link="/contents/demand/dmdDecideAllPrice"
      description="個人受診情報毎に作成された金額情報を最新設定情報を元に再作成します。"
      image=""
    />
    <MenuItem
      title="締め処理"
      link="/contents/demand/dmdaddup"
      description="指定範囲内の受診情報から請求締め処理を行います。"
      image=""
    />
    <MenuItem
      title="請求書照会、修正"
      link="/contents/demand/burdenlist"
      description="団体様への請求書を参照、修正します。"
      image=""
    />
    <MenuItem
      title="日次締め処理"
      link="/contents/demand/peraddup"
      description="当日の請求締め処理を行います。"
      image=""
    />
    <MenuItem
      title="請求書削除"
      link="/contents/demand/deleteDmd"
      description="指定された締め日の請求書を一括して削除します。"
      image=""
    />
    <MenuItem
      title="団体一括入金処理"
      link="/contents/demand/dmdPayment"
      description="団体様からの入金情報を一括登録します。"
      image=""
    />
    <MenuItem
      title="請求書発送確認日設定"
      link="/contents/demand/dmdSendCheckDay"
      description="団体様への請求書を、発送します。"
      image=""
    />
  </PageLayout>
);

export default Menu;
