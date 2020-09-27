import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import PageLayout from '../../layouts/PageLayout';
import MngaccuracyInfoBody from './MngaccuracyInfoBody';
import MngaccuracyInfoHeaderForm from './MngaccuracyInfoHeaderForm';


const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const MngaccuracyInfo = (props) => {
  const { searched, conditions, mngdata, border, message } = props;
  return (
    <PageLayout title="精度管理">
      <MngaccuracyInfoHeaderForm />
      {searched && message.length === 0 && (
        <div>
          <div>
            「<TotalCount>{conditions.strcsldate}</TotalCount>」の検査結果情報を表示しています。検索結果は<TotalCount>{mngdata.length}</TotalCount>件ありました。
          </div>
          <MngaccuracyInfoBody data={mngdata} border={border} />
        </div>
      )}

    </PageLayout>
  );
};
// propTypesの定義
MngaccuracyInfo.propTypes = {
  conditions: PropTypes.shape().isRequired,
  searched: PropTypes.bool.isRequired,
  mngdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  border: PropTypes.string,
};

// defaultPropsの定義
MngaccuracyInfo.defaultProps = {
  border: null,
};

const mapStateToProps = (state) => ({
  conditions: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.conditions,
  message: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.message,
  mngdata: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.mngdata,
  searched: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.searched,
  border: state.app.dailywork.mngAccuracy.mngaccuracyInfoList.conditions.border,
});

export default connect(mapStateToProps)(MngaccuracyInfo);
