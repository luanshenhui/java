import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import moment from 'moment';
import PageLayout from '../../../layouts/PageLayout';
import MessageBanner from '../../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';
import BulletedLabel from '../../../components/control/BulletedLabel';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import LabelCourse from '../../../components/control/label/LabelCourse';
import Button from '../../../components/control/Button';
import Table from '../../../components/Table';
import * as Constants from '../../../constants/common';

import { getCtrMngReferRequest, referContractRequest, copyContractRequest } from '../../../modules/preference/contractModule';

const WrapperBrowseCopy = styled.div`
  .bullet { color: #cc9999 };
`;

const WrapperMessage = styled.span`
   color: #666666;
`;

// 参照・コピー可能な契約情報が存在するかをチェックする
const LabelBrowseCopy = ({ opname, opmode, data }) => {
  let label = '';
  let isBrowseCopy = false;
  if (opmode === Constants.OPMODE_BROWSE) {
    for (let i = 0; i < data.length; i += 1) {
      if (data[i].orgequals === 0 && data[i].referred === 0 && data[i].overlap === 0 && data[i].existbdn === 0) {
        isBrowseCopy = true;
        break;
      }
    }
  } else {
    for (let i = 0; i < data.length; i += 1) {
      if (data[i].existbdn === 0) {
        isBrowseCopy = true;
        break;
      }
    }
  }
  label = isBrowseCopy ? <BulletedLabel>{opname}を行う契約情報を以下から選択して下さい。</BulletedLabel> : <BulletedLabel>{opname}可能な契約情報は存在しませんでした。</BulletedLabel>;
  return label;
};

// 参照・コピー可能な契約情報が存在するかをチェックする
const LabelMessage = ({ opname, opmode, record, match, history, onSelectRowSubmit }) => {
  let error = '';
  // エラーメッセージの編集
  // 処理モードが参照の場合は次の3つのチェック処理を行う
  if (opmode === Constants.OPMODE_BROWSE) {
    if (record.orgequals === 1) {
      // 契約団体自身の契約情報を参照している場合
      error = '（参照先団体が契約団体自身の契約を参照しています。）';
    } else if (record.referred === 1) {
      // すでに契約団体自身から参照されている場合
      error = '（この契約情報はすでに契約団体自身から参照されています。）';
    } else if (record.overlap === 1) {
      // 契約期間が重複する場合
      error = `（契約団体の現契約情報と契約期間が重複するため、${opname}することはできません。）`;
    }
  }
  if (error === '' && record.existbdn === 1) {
    // 契約団体が参照先契約団体契約情報の負担元として存在する場合
    error = `（契約団体自身が負担元として存在する契約情報の${opname}はできません。）`;
  }
  let label = null;
  const { params } = match;
  if (error === '') {
    label = (
      <a
        role="presentation"
        onClick={() => onSelectRowSubmit(record.ctrptcd, params, () => history.push(`/contents/preference/contract/${match.params.orgcd1}/${match.params.orgcd2}/finish`))}
      ><span style={{ color: '#006699' }}>この契約情報を{opname}する</span >
      </a>);
  } else {
    label = <WrapperMessage > { error }</WrapperMessage >;
  }
  return label;
};

class CtrBrowseContract extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    history.goBack();
  }

  render() {
    const { history, match, message, data, onSelectRowSubmit } = this.props;
    // 処理名の編集
    const opName = match.params.opmode === Constants.OPMODE_BROWSE ? '参照' : 'コピー';

    return (
      <PageLayout title="契約情報の選択">
        <MessageBanner messages={message} />
        <div>
          <Button onClick={this.handleCancelClick} value="戻 る" />
        </div>
        <div>
          <FieldGroup itemWidth={90}>
            <FieldSet>
              <FieldItem>契約団体</FieldItem>
              <LabelOrgName orgcd1={match.params.orgcd1} orgcd2={match.params.orgcd2} />
            </FieldSet>
            <FieldSet>
              <FieldItem>対象コース</FieldItem>
              <LabelCourse cscd={match.params.cscd} />
            </FieldSet>
            {match.params.opmode === Constants.OPMODE_COPY && (
              <FieldSet>
                <FieldItem>契約期間</FieldItem>
                <Label>{moment(match.params.strdate).format('YYYY年MM月DD日')}～{moment(match.params.enddate).format('YYYY年MM月DD日')}</Label>
              </FieldSet>
            )}
          </FieldGroup>
          <FieldGroup itemWidth={120}>
            <FieldSet>
              <FieldItem>参照先契約団体</FieldItem>
              <LabelOrgName orgcd1={match.params.reforgcd1} orgcd2={match.params.reforgcd2} />
            </FieldSet>
          </FieldGroup>
        </div>
        <WrapperBrowseCopy>
          <LabelBrowseCopy opname={opName} opmode={match.params.opmode} data={data} />
        </WrapperBrowseCopy>
        <br />
        <div>
          <Table style={{ width: '80%' }}>
            <thead>
              <tr>
                <th>契約期間</th>
                <th>備考</th>
              </tr>
            </thead>
            <tbody>
              {data.map((rec, index) => (
                <tr key={index.toString()} >
                  <td style={{ width: '140px' }}>{moment(rec.strdate).format('YYYY/MM/DD')}～{moment(rec.enddate).format('YYYY/MM/DD')}</td>
                  <td><LabelMessage opname={opName} opmode={match.params.opmode} record={rec} match={match} onSelectRowSubmit={onSelectRowSubmit} history={history} /></td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
      </PageLayout>
    );
  }
}

// propTypesの定義
CtrBrowseContract.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSelectRowSubmit: PropTypes.func.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  message: state.app.preference.contract.ctrBrowseContract.message,
  data: state.app.preference.contract.ctrBrowseContract.data,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    // 現在編集中コースに対する参照先団体契約情報の参照・コピー処理可否を取得する
    dispatch(getCtrMngReferRequest({ ...params }));
  },
  // 参照・コピーの処理
  onSelectRowSubmit: (ctrptcd, data, redirect) => {
    const { opmode } = data;
    // 参照・コピーの処理
    if (opmode === Constants.OPMODE_BROWSE) {
      // 参照の場合
      dispatch(referContractRequest({ ...data, ctrptcd, redirect }));
    } else if (opmode === Constants.OPMODE_COPY) {
      // コピーの場合
      dispatch(copyContractRequest({ ...data, ctrptcd, redirect }));
    }
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrBrowseContract);
