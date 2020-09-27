import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import SectionBar from '../../components/SectionBar';
import LabelWebOptName from '../../components/control/label/LabelWebOptName';

// 氏名については、個人ID存在時は個人情報から、さもなくばweb予約情報から取得
const getName = (data) => {
  const res = [];
  let editperid;
  let editfullname;
  let editkananame;
  if (data.perid !== null) {
    editperid = data.perid;
    editfullname = `${data.lastname} ${data.firstname}`;
    editkananame = `${data.lastkname} ${data.firstkname}`;
    if (editfullname !== '') {
      editfullname = data.fullname;
    }
    if (editkananame !== '') {
      editkananame = data.kananame;
    }
  } else {
    editperid = '【新規】';
    editfullname = data.fullname;
    editkananame = data.kananame;
  }
  const editromaname = data.romaname;
  res.push(<div key="editperid" style={{ paddingTop: '54px' }} > {editperid}</div >);
  res.push(<div key="editromaname" >{editromaname}<br />{editkananame}<br />{editfullname}<br /></div>);
  return res;
};

// 郵便番号指定時のみ列を表示
const getZip = (data) => {
  let zipno1;
  let zipno2;
  let editzipno;
  if (data.zipno) {
    zipno1 = data.zipno.substr(0, 3);
    zipno2 = data.zipno.substr(3, 8);
    editzipno = zipno1 + (zipno2 !== null ? '-' : '') + zipno2;
  }
  return editzipno;
};
// 本人家族区分の名称変換
const getSupportDiv = (div) => {
  let editsupportdiv;
  if (div === '1') {
    editsupportdiv = '本人（被保険者）';
  } else if (div === '2') {
    editsupportdiv = '家族（被扶養者）';
  }
  return editsupportdiv;
};
// 英文出力区分の名称変換
const getOutEng = (outeng) => {
  let editouteng;
  if (outeng === 0) {
    editouteng = '無';
  } else if (outeng === 1) {
    editouteng = '有';
  }
  return editouteng;
};
// ボランティア区分変換
const getVolunteer = (volunteer) => {
  let editvolunteer;
  if (volunteer === 0) {
    editvolunteer = '利用なし';
  } else if (volunteer === 1) {
    editvolunteer = '通訳要';
  } else if (volunteer === 2) {
    editvolunteer = '介護要';
  } else if (volunteer === 3) {
    editvolunteer = '通訳＆介護要';
  } else if (volunteer === 4) {
    editvolunteer = '車椅子要';
  }
  return editvolunteer;
};

// 受診オプションコードのカンマ結合文字列が存在する場合はその内容をもとにオプション名を表示
const getCslOptions = (data) => {
  let editOptionStomac = '';
  let editOptionBreast = '';
  const res = [];
  // 胃検査の名称変換
  if (data.optionstomac === 1) {
    editOptionStomac = '胃Ｘ線';
  } else if (data && data.optionstomac === 2) {
    editOptionStomac = '胃内視鏡';
  }

  // 乳房検査の名称変換
  if (data.optionbreast === 1) {
    editOptionBreast = '乳房Ｘ線';
  } else if (data && data.optionbreast === 2) {
    editOptionBreast = '乳房超音波';
  } else if (data && data.optionbreast === 3) {
    editOptionBreast = '乳房Ｘ線・乳房超音波';
  }

  if (data.csloptions !== null) {
    res.push(<LabelWebOptName key={data.csloptions} csloptions={data.csloptions} />);
  } else {
    res.push({ editOptionStomac });
    if (editOptionStomac !== '' && editOptionBreast !== '') {
      res.push('、');
    }
    res.push({ editOptionBreast });
  }
  return res;
};

const WebOrgRsvReservation = ({ webOrgRsvData, age }) => (
  <div style={{ height: '480px', overflow: 'auto', width: '495px' }}>
    <SectionBar title="申し込み情報" />
    <FieldGroup itemWidth={200}>
      <FieldSet>
        <FieldItem key="webreqno" >申込番号</FieldItem>
        {webOrgRsvData && webOrgRsvData.webreqno}
      </FieldSet>
      <FieldSet>
        <FieldItem>申込日</FieldItem>
        {moment(webOrgRsvData && webOrgRsvData.insdate).format('YYYY年M月D日 HH:mm:ss')}
      </FieldSet>
      <FieldSet>
        <FieldItem>氏名</FieldItem>
        {webOrgRsvData && getName(webOrgRsvData)}
      </FieldSet>
      <FieldSet>
        <FieldItem>&nbsp;</FieldItem>
        {webOrgRsvData && webOrgRsvData.birthyearshorteraname}
        {webOrgRsvData && webOrgRsvData.birtherayear}&nbsp;&nbsp;
        {moment(webOrgRsvData && webOrgRsvData.birth).format('MM.DD')}生&nbsp;&nbsp;
        {webOrgRsvData && Math.floor(Number(age))}歳 &nbsp;&nbsp;
        {webOrgRsvData && webOrgRsvData.gender === 1 ? '男性' : '女性'}
      </FieldSet>
      <FieldSet>
        <FieldItem>自宅住所</FieldItem>
        {webOrgRsvData && getZip(webOrgRsvData)}&nbsp;{webOrgRsvData && webOrgRsvData.address1}{webOrgRsvData && webOrgRsvData.address2}{webOrgRsvData && webOrgRsvData.address3}
      </FieldSet>
      <FieldSet>
        <FieldItem>TEL</FieldItem>
        {webOrgRsvData && webOrgRsvData.tel}
      </FieldSet>
      <FieldSet>
        <FieldItem>e-mail</FieldItem>
        {webOrgRsvData && webOrgRsvData.email}
      </FieldSet>
      <FieldSet>
        <FieldItem>勤務先</FieldItem>
        {webOrgRsvData && webOrgRsvData.officename}
      </FieldSet>
      <FieldSet>
        <FieldItem>TEL</FieldItem>
        {webOrgRsvData && webOrgRsvData.officetel}
      </FieldSet>
      <FieldSet>
        <FieldItem>国籍</FieldItem>
        {webOrgRsvData && webOrgRsvData.nation}
      </FieldSet>
      <FieldSet>
        <FieldItem>申込団体</FieldItem>
        {webOrgRsvData && webOrgRsvData.orgname}
      </FieldSet>
      <FieldSet>
        <FieldItem>区分</FieldItem>
        {webOrgRsvData && getSupportDiv(webOrgRsvData.supportdiv)}
      </FieldSet>
      <FieldSet>
        <FieldItem>保険証記号</FieldItem>
        {webOrgRsvData && webOrgRsvData.isrsign}
      </FieldSet>
      <FieldSet>
        <FieldItem>保険証番号</FieldItem>
        {webOrgRsvData && webOrgRsvData.isrno}
      </FieldSet>
      <FieldSet>
        <FieldItem>ボランティア</FieldItem>
        {webOrgRsvData && getVolunteer(webOrgRsvData.volunteer)}
      </FieldSet>
      <FieldSet>
        <FieldItem>確認はがき英文出力</FieldItem>
        {webOrgRsvData && getOutEng(webOrgRsvData.cardouteng)}
      </FieldSet>
      <FieldSet>
        <FieldItem>一式書式英文出力</FieldItem>
        {webOrgRsvData && getOutEng(webOrgRsvData.formouteng)}
      </FieldSet>
      <FieldSet>
        <FieldItem>成績表英文出力</FieldItem>
        {webOrgRsvData && getOutEng(webOrgRsvData.reportouteng)}
      </FieldSet>
      <FieldSet>
        <FieldItem>セット</FieldItem>
        {webOrgRsvData && getCslOptions(webOrgRsvData)}
      </FieldSet>
      <FieldSet>
        <FieldItem>キャンセル対象予約日</FieldItem>
        {webOrgRsvData && webOrgRsvData.hcsldate}
      </FieldSet>
      <FieldSet>
        <FieldItem>キャンセル対象予約番号</FieldItem>
        {webOrgRsvData && webOrgRsvData.hrsvno}
      </FieldSet>
      <FieldSet>
        <FieldItem>キャンセル対象個人ID</FieldItem>
        {webOrgRsvData && webOrgRsvData.hperid}
      </FieldSet>
      <FieldSet>
        <FieldItem>キャンセル対象氏名</FieldItem>
        {webOrgRsvData && webOrgRsvData.hpername}
      </FieldSet>
      <FieldSet>
        <FieldItem>予約時メッセージ</FieldItem>
        {webOrgRsvData && webOrgRsvData.message}
      </FieldSet>
    </FieldGroup>
  </div>
);

// propTypesの定義
WebOrgRsvReservation.propTypes = {
  webOrgRsvData: PropTypes.shape(),
  age: PropTypes.string,
};

WebOrgRsvReservation.defaultProps = {
  webOrgRsvData: null,
  age: null,
};

export default WebOrgRsvReservation;
