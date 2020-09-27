import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Field, getFormValues, reduxForm } from 'redux-form';
import { connect } from 'react-redux';

import { getFolReqHistoryRequest } from '../../modules/followup/followModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DropDown from '../../components/control/dropdown/DropDown';
import Button from '../../components/control/Button';

const formName = 'FolUpdateHistoryHeader';

const WrapperSpace = styled.span`
  padding: 0 15px;
`;

const prtdiv = [
  { value: '', name: '' },
  { value: 1, name: '依頼' },
  { value: 2, name: '勧奨' },
];

class FolUpdateHistoryHeader extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 検索ボタンを押下
  handleSubmit(values) {
    const { onSearch, rsvno } = this.props;
    onSearch({ ...values, rsvno });
  }

  render() {
    const { handleSubmit, followItem, formValues } = this.props;
    const judclasscd = [];
    for (let i = 0; i < followItem.length; i += 1) {
      if (i === 0) {
        judclasscd.push({ value: null, name: null });
      }
      judclasscd.push({ value: followItem[i].itemcd, name: followItem[i].itemname });
    }
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <FieldGroup itemWidth={80}>
            <FieldSet>
              <FieldItem>検査項目</FieldItem>
              <Field name="judclasscd" component={DropDown} items={judclasscd} id="judclasscd" selectedValue="0" />
              <WrapperSpace />
              <FieldItem>様式区分</FieldItem>
              <Field name="prtdiv" component={DropDown} items={prtdiv} id="prtdiv" selectedValue="0" />
              <WrapperSpace />
              <Button style={{ marginLeft: '100px' }} onClick={() => this.handleSubmit(formValues)} value="表示" />
            </FieldSet>
          </FieldGroup>
        </div>
      </form>
    );
  }
}

const FolUpdateHistoryHeaderFrom = reduxForm({
  form: formName,
})(FolUpdateHistoryHeader);

// propTypesの定義
FolUpdateHistoryHeader.propTypes = {
  onSearch: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  followItem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rsvno: PropTypes.number.isRequired,
  formValues: PropTypes.shape(),
};

FolUpdateHistoryHeader.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    followItem: state.app.followup.follow.folReqHistoryGuide.followItem,
    judclasscd: null,
    prtdiv: '',
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSearch: (params) => {
    dispatch(getFolReqHistoryRequest(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FolUpdateHistoryHeaderFrom);
