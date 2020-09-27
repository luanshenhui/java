import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import moment from 'moment';
import SectionBar from '../../components/SectionBar';
import MessageBanner from '../../components/MessageBanner';
import { getInterviewConsultRequest } from '../../modules/judgement/interviewModule';
import { getFreeByClassCdRequest } from '../../modules/preference/freeModule';
import { FieldGroup, FieldSet } from '../../components/Field';
import * as contants from '../../constants/common';

const ingGender = 2;

const Gechgdatet = (chgDateInfo) => {
  const chgdate = [];
  chgDateInfo.map((rec) => (
    chgdate.push(rec.freefield1)
  ));
  let strchgdate = chgdate[0];
  if (strchgdate === '') {
    strchgdate = contants.CHECK_CSLDATE2;
  }
  return strchgdate;
};

class MonshinNyuryokuHeader extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.rsvno = match.params.rsvno;
  }
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  render() {
    const { consultInfo, message, chgDateInfo } = this.props;
    return (
      <div >
        <MessageBanner messages={message} />
        <div> <SectionBar title="生活習慣" /> </div>
        <FieldGroup itemWidth={200}>
          <FieldSet>
            { /* TODO 胃検査・他院での指摘ウインドウ呼び出し */}
            <a href="#">胃検査・他院での指摘</a>
            <div style={{ width: '55px' }} />
            { /* TODO ＯＣＲ入力結果確認ウインドウ呼び出し */}
            <a href="#">ＯＣＲ入力結果確認</a>
            <div style={{ width: '505px' }} />
            {(consultInfo && consultInfo.gender === ingGender && moment(consultInfo.csldate).format('YYYY/MM/DD') >= <Gechgdatet chgDateInfo={chgDateInfo} />)
              ? <a href="#">婦人科問診詳細</a>
            : ''}
            {(consultInfo && consultInfo.gender === ingGender && moment(consultInfo.csldate).format('YYYY/MM/DD') < <Gechgdatet chgDateInfo={chgDateInfo} />)
              ? <a href="#">婦人科問診詳細</a>
            : ''}
          </FieldSet>
        </FieldGroup>
      </div>
    );
  }
}

MonshinNyuryokuHeader.propTypes = {
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  consultInfo: PropTypes.shape(),
  chgDateInfo: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

MonshinNyuryokuHeader.defaultProps = {
  consultInfo: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  message: state.app.judgement.interview.consultData.message,
  consultInfo: state.app.judgement.interview.consultData.data,
  chgDateInfo: state.app.preference.free.freeByClassCd.data,

});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    dispatch(getInterviewConsultRequest(params));

    const mode = 0;
    const freeclasscd = contants.FREECLASSCD_CHG;
    dispatch(getFreeByClassCdRequest({ mode, freeclasscd }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(MonshinNyuryokuHeader));
