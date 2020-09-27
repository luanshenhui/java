import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import SectionBar from '../../components/SectionBar';
import RslDetailHeader from './RslDetailHeader';
import RslDetailBody from './RslDetailBody';

const RslDetail = (props) => (
  <div>
    <SectionBar title="結果入力" />
    {
      props.curRsvNoPrevNext !== undefined && (
        <div>
          <div>
            <RslDetailHeader />
          </div>
          <div>
            <RslDetailBody />
          </div>
        </div>
      )
    }
  </div>
);
// propTypesの定義
RslDetail.propTypes = {
  curRsvNoPrevNext: PropTypes.shape().isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  curRsvNoPrevNext: state.app.result.result.rslDailyList.curRsvNoPrevNext,
});

export default connect(mapStateToProps)(RslDetail);
