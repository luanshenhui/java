import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import qs from 'qs';
import { connect } from 'react-redux';
import Label from '../../components/control/Label';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import SectionBar from '../../components/SectionBar';
import EditCsGrpInfo from './EditCsGrpInfo';

import { getConsultHistoryJudHeaderRequest } from '../../modules/judgement/interviewModule';

class TotalJudHeader extends React.Component {
  componentDidMount() {
    this.doSearch(this.props);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { params } = nextProps;
    if (params.csgrp !== this.props.params.csgrp) {
      this.doSearch(nextProps);
    }
  }

  // 前回受診日
  getCsldateBefore = (data) => {
    let res;
    if (data !== undefined) {
      if (data.length > 1) {
        const date = moment(data[1].csldate).format('M/D/YYYY');
        res = date;
      }
    }
    return res;
  };

  // 前回受診日名称
  getCsnameBefore = (data) => {
    let res;
    if (data) {
      if (data.length > 1) {
        res = data[1].cssname;
      }
    }
    return res;
  };

  // 前々回受診日
  getCsldate = (data) => {
    let res;
    if (data) {
      if (data.length > 2) {
        const date = moment(data[2].csldate).format('M/D/YYYY');
        res = date;
      }
    }
    return res;
  };

  // 前々回受診日名称
  getCsname = (data) => {
    let res;
    if (data) {
      if (data.length > 2) {
        res = data[2].cssname;
      }
    }
    return res;
  };

  // 虚血性心疾患
  handleCallMenKyoketsuClick = () => {
  }

  // 食習慣
  handleCallShokushukanClick = () => {
  }

  // 栄養指導
  handleCallMenEiyoShidoClick = () => {
  }

  // CU経年変化
  handleCallCUSelectItemsMainClick = () => {
  }

  // 変更履歴
  handleCallrslUpdateHistoryClick = () => {
  }

  // 前回フォローアップ
  handleCallFollowupBeforeClick = () => {
  }

  // フォローアップ
  handleCallFollowupNyuryokuClick = () => {
  }

  // 担当者登録
  handleShowTantouClick = () => {
  }

  // 電子チャート情報
  handleHainsEgmainConnectClick = () => {
  }

  doSearch = (props) => {
    const { onSearch, params } = props;

    // 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
    let lngLastDspMode;
    let vntCsGrp;
    let strSelCsGrp = params.csgrp;
    strSelCsGrp = ((!strSelCsGrp || strSelCsGrp === '') ? '0' : strSelCsGrp);

    switch (strSelCsGrp) {
      // すべてのコース
      case '0':
        lngLastDspMode = 0;
        vntCsGrp = '';
        break;
      // 同一コース
      case '1':
        lngLastDspMode = 1;
        vntCsGrp = params.cscd;
        break;
      default:
        lngLastDspMode = 2;
        vntCsGrp = strSelCsGrp;
    }
    onSearch({ rsvNo: params.rsvno, receptOnly: false, lastDspMode: lngLastDspMode, csGrp: vntCsGrp, getRowCount: 3, selectMode: 0 });
  }

  // 表示
  handleHyouJiClick = (values) => {
    const { match, history, consultHistoryData } = this.props;
    let { params } = this.props;

    // 今回コースコード退避
    if (consultHistoryData && consultHistoryData.length > 0) {
      params = { ...params, cscd: consultHistoryData[0].cscd };
    }

    history.push({
      pathname: match.url,
      search: qs.stringify({ ...params, ...values }),
    });
  }

  // 描画処理
  render() {
    const { consultHistoryData, handleSubmit } = this.props;
    let { params } = this.props;

    // 今回コースコード退避
    if (consultHistoryData && consultHistoryData.length > 0) {
      params = { ...params, cscd: consultHistoryData[0].cscd };
    } else {
      return null;
    }

    return (
      <div>
        <SectionBar title="総合判定" />
        <EditCsGrpInfo rsvno={parseInt(params.rsvno, 10)} handleSubmit={handleSubmit} dispCalledFunction={this.handleHyouJiClick} data={consultHistoryData} />
        <FieldGroup itemWidth={100}>
          <FieldSet>
            <FieldItem>前回受診日</FieldItem>
            <Label name=""><font color="#ff6600"><b>{this.getCsldateBefore(consultHistoryData)}</b></font></Label>
            <Label name=""><font color="#ff6600"><b>{this.getCsnameBefore(consultHistoryData)}</b></font></Label>
            <FieldItem>前々回受診日</FieldItem>
            <Label name=""><font color="#ff6600"><b>{this.getCsldate(consultHistoryData)}</b></font></Label>
            <Label name=""><font color="#ff6600"><b>{this.getCsname(consultHistoryData)}</b></font></Label>
          </FieldSet>
        </FieldGroup>
      </div>
    );
  }
}

// propTypesの定義
TotalJudHeader.propTypes = {
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  params: PropTypes.shape().isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
};

const mapStateToProps = (state) => ({
  classCdData: state.app.judgement.interview.interView.classCdData,
  followBeforeData: state.app.judgement.interview.interView.followBeforeData,
  followInfoData: state.app.judgement.interview.interView.followInfoData,
  targetFollowData: state.app.judgement.interview.interView.targetFollowData,
  consultHistoryData: state.app.judgement.interview.interView.judHeader.consultHistoryData,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    // 検索条件に従い受診情報一覧を抽出する
    dispatch(getConsultHistoryJudHeaderRequest({ ...conditions }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(TotalJudHeader);
