import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { closeMergeGuide, clearMessage } from '../../modules/bill/perBillModule';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import MergePerBillGuide1 from './MergePerBillGuide1';
import MergePerBillGuide2 from './MergePerBillGuide2';

const Wrapper = styled.div`
  height: 550px;
  width: 850px;
  margin-top: 10px;
  overflow-y: auto;
`;

class MergePerBill extends React.Component {
  constructor(props) {
    super(props);
    this.nextPage = this.nextPage.bind(this);
    this.previousPage = this.previousPage.bind(this);
    this.state = {
      page: 1,
      curPage: 1,
    };
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible } = this.props;
    if (visible && nextProps.visible !== visible) {
      this.setState({
        page: 1,
        curPage: 1,
      });
    }
  }

  nextPage() {
    this.setState({
      page: this.state.page + 1,
      curPage: this.state.page,
    });
  }

  previousPage() {
    const { onClearMessage } = this.props;
    onClearMessage();
    this.setState({
      page: this.state.page - 1,
      curPage: this.state.page,
    });
  }

  render() {
    const { page } = this.state;
    const { message, perBillCsl } = this.props;
    const guideTitle = () => {
      switch (page) {
        case 1:
          return '請求書統合処理';
        case 2:
          return '請求統合処理';
        default:
          return '';
      }
    };

    return (
      <GuideBase {...this.props} title={guideTitle()} usePagination={false}>
        <Wrapper>
          <MessageBanner messages={message} />
          {(page === 1 && perBillCsl.length > 0) && (
            <MergePerBillGuide1
              onNext={this.nextPage}
              curPage={this.state.curPage}
            />
          )}
          {page === 2 && (
            <MergePerBillGuide2
              onBack={this.previousPage}
              onNext={this.nextPage}
            />
          )}
        </Wrapper>
      </GuideBase>
    );
  }
}

// propTypesの定義
MergePerBill.propTypes = {
  // stateと紐付けされた項目
  perBillCsl: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  onClearMessage: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  visible: state.app.bill.perBill.mergeGuide.visible,
  message: state.app.bill.perBill.mergeGuide.message,
  perBillCsl: state.app.bill.perBill.mergeGuide.perBillCsl,
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeMergeGuide());
  },

  onClearMessage: () => {
    dispatch(clearMessage());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MergePerBill);
