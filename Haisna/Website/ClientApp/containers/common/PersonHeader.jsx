import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import moment from 'moment';
import { FieldGroup, FieldSet, FieldValueList, FieldValue } from '../../components/Field';
import { getPerInspectionRequest } from '../../modules/preference/personModule';

class PersonHeader extends React.Component {
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  render() {
    const { personInfo, perid } = this.props;
    return (
      <div>
        <FieldGroup itemWidth={200}>
          <FieldSet>
            {personInfo.birtherayear && perid}
            <FieldValueList>
              <FieldValue>
                <span style={{ fontSize: '16px', fontWeight: 'bold' }} >&nbsp;{personInfo.lastname}&nbsp;{personInfo.firstname}&nbsp;</span>
              ({personInfo.lastkname}&nbsp;{personInfo.firstkname})
              </FieldValue>
              <FieldValue>
                {personInfo.birthyearshorteraname && personInfo.birthyearshorteraname}
                {personInfo.birtherayear && (`${personInfo.birtherayear}.${moment(personInfo.birth).format('MM.DD')}`)}生
                &nbsp;{personInfo.age && personInfo.age}歳 &nbsp; {personInfo.gendername && personInfo.gendername}
              </FieldValue>
            </FieldValueList>
          </FieldSet>
        </FieldGroup>
      </div>
    );
  }
}

PersonHeader.propTypes = {
  onLoad: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  perid: PropTypes.string,
  personInfo: PropTypes.shape().isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  personInfo: state.app.preference.person.perInspection.personInfo,
});

PersonHeader.defaultProps = {
  perid: '',
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { perid } = params;
    if (perid === undefined) {
      return;
    }
    dispatch(getPerInspectionRequest({ params }));
  },
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(PersonHeader));
