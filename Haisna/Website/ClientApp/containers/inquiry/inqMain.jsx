import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import PageLayout from '../../layouts/PageLayout';
import SectionBar from '../../components/SectionBar';

import InqHistory from './InqHistory';
import InqPerInspection from './InqPerInspection';

import { getInquiryHistoryRequest, getInqPerInspectionRequest } from '../../modules/inquiry/inquiryModule';

const Wrapper = styled.div`
  width: 600px;
`;

const TitleSpan = styled.span`
  font-weight: bold;
  color: #FF6600;
`;

class InqMain extends React.Component {
  componentDidMount() {
    const { onLoad, match } = this.props;

    onLoad(match.params);
  }

  render() {
    const { match, personInf, consultHistory, consultHistoryCnt, consultHistoryIns, perResultList } = this.props;

    const { perid } = match.params;

    return (
      <PageLayout title="結果参照">
        <Wrapper>
          <TitleSpan>{personInf && `[${personInf.lastkname}  ${personInf.firstkname == null ? '' : personInf.firstkname}]`}</TitleSpan>
          <div>
            の受診歴は <TitleSpan> {consultHistoryCnt}</TitleSpan>件ありました。
          </div>
          <SectionBar title="対象者" />
          <InqHistory perid={perid} personInf={personInf} consultHistory={consultHistory} />

          <SectionBar title="個人情報" />
          <InqPerInspection consultHistoryIns={consultHistoryIns} perResultList={perResultList} mode="1" />
        </Wrapper>
      </PageLayout>
    );
  }
}

InqMain.propTypes = {
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  personInf: PropTypes.shape().isRequired,
  consultHistory: PropTypes.arrayOf(PropTypes.shape()),
  consultHistoryCnt: PropTypes.number.isRequired,
  consultHistoryIns: PropTypes.arrayOf(PropTypes.shape()),
  perResultList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

// defaultPropsの定義
InqMain.defaultProps = {
  consultHistory: null,
  consultHistoryIns: null,
};

const mapStateToProps = (state) => ({
  personInf: state.app.inquiry.inquiry.inqMain.personInf,
  consultHistory: state.app.inquiry.inquiry.inqMain.consultHistory,
  consultHistoryCnt: state.app.inquiry.inquiry.inqMain.consultHistoryCnt,
  consultHistoryIns: state.app.inquiry.inquiry.inqMain.consultHistoryIns,
  perResultList: state.app.inquiry.inquiry.inqMain.perResultList,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 結果参照 対象者を取得
    dispatch(getInquiryHistoryRequest({ params }));
    // 個人検査情報を取得
    dispatch(getInqPerInspectionRequest({ params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(InqMain);
